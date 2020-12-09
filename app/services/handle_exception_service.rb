

# NAVITIME APIでエラーが発生した際の例外処理専用クラス
class HandleExceptionService

  def self.rescue(errored_variant)

    # stats_codeが存在する場合（パラメータエラーかリクエストエラーか不明なエラー）
    if errored_variant.keys.include?("status_code")
          
      if 400 <= errored_variant["status_code"] && errored_variant["status_code"] < 500
        return "Parameter error"
      elsif 500 <= errored_variant["status_code"]
        return "Request error"
      else 
        return "Invalid error"
      end

    # ノード変換エラー
    elsif errored_variant.keys.include?("count") && errored_variant["count"]["total"] == 0

      return "Request error"

    # API使用超過エラー
    elsif errored_variant.keys.include?("message") && (errored_variant["message"].include?("You have exceeded") || errored_variant["message"].include?("You are not subscribed to this API."))
      
      return "Exceeding error"

    # 不明なエラー
    else
      
      return "Invalid error"
    
    end

  end


  def self.update_comment(error_str)

    case error_str
    
    when "Parameter error" then
      
      return "パラメータエラーです。コード修正の必要があります。"
    
    when "Request error" then

      return "リクエストエラーです。駅名が正しいかもう一度確認してください。"
    
    when "Exceeding error" then

      return "NAVITIME APIアクセス上限に達したため、経路検索機能がご利用いただけません。大変申し訳ございません。"
    
    else
    
      return "原因不明のエラーです。アプリ開発者にご連絡ください。"
    
    end

  end

end