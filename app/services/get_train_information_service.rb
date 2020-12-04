

class GetTrainInformationService

  # TrainAPIから運行情報を取得し、異常が発生している路線の情報をreturnするメソッド
  def self.fetch

    # サービスクラスFetchTrainsApisServiceから各路線の運行情報レスポンスを取得
    train_information = FetchTrainsApisService.fetch(FetchTrainsApisService.apis[:ti])
    
    # 運行情報を格納する空配列を定義
    information_list = []

    # 各路線情報ごとにループ
    train_information.each do |train_info|

      # 正常運転しているかを格納するkey（正常運転していなければこのkeyが存在する）
      train_status_str = "odpt:trainInformationStatus"
      # 運行情報を文字列で格納しているkey
      train_infomation_text_str = "odpt:trainInformationText"

      # 各路線が以上運転しているかを判定
      if train_info.keys.include?(train_status_str) && !train_info[train_status_str].nil?

        # 現在の運転状況を日本語で格納
        information_list << train_info[train_infomation_text_str]["ja"]

      end

      unless information_list.empty?

        information_list.uniq!

      end

      return information_list

    end

  end

end