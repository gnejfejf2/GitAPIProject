//
//  ScrollPagingProtocol.swift
//  cmproject
//
//  Created by 강지윤 on 2022/02/23.
//

import Foundation

//프로토콜 자체에서 데이터 변환이 일어나기때문에
//Class 에서만 사용이가능하도록 AnyObject 채택
protocol ScrollPagingProtocl : AnyObject {
    
    var totalCount : Int { get set}
    
    var itemCount : Int { get }
    //스크롤 에따른 페이징 체크
    //해당값이 True 일때만 추가로 요청을한다
    var scrollPagingCall : Bool { get set }
    //페이징카운트
    var pagingCount : Int  { get set }
  
   
    func pagingCountClear()
    
    func pagingCountChecking(requestItemCount : Int)
    
}



class SuperScrollPagingProtocol : ScrollPagingProtocl {
    var totalCount: Int = 0
    
    var itemCount: Int = 30
    
    var scrollPagingCall: Bool = true
    
    var pagingCount: Int = 1

  
   

    
    func uiDrawing() {
       
     
    }
    
    func uiSetting() {

       
    }
    
    func viewModelBinding() {
        
    }
    
    
    

}



extension ScrollPagingProtocl {
    

    
    func pagingCountClear(){
        self.totalCount = 0
        
        self.scrollPagingCall = true
        
        self.pagingCount  = 1
        
    }
    //요청하는 아이템의 갯수는 30개
    //최초시작
    //ex 0개 1페이지 30개 요청
    //ex 30개 1페이지 30개
    //점검
    //
    func pagingCountChecking(requestItemCount : Int)  {
        self.totalCount += requestItemCount
  
        if(self.totalCount < self.itemCount * self.pagingCount){
            self.scrollPagingCall = false
        }else{
            self.pagingCount += 1
        }
    }
    
}
