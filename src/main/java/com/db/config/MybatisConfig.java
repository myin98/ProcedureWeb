package com.db.config;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.transaction.TransactionFactory;
import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

@Configuration
public class MybatisConfig {
	@Bean
	public SqlSessionFactory sqlSessionFactory(DataSource dataSource, ApplicationContext applicationContext) throws Exception {
		SqlSessionFactoryBean sessionFactoryBean = new SqlSessionFactoryBean();
		sessionFactoryBean.setDataSource(dataSource);
		sessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:/sql/*.xml"));

		// 서로 다른 시스템 연결 후 성공 및 실패 관리 (트랜잭션 정보)
		TransactionFactory trn= new JdbcTransactionFactory();
		trn.newTransaction(dataSource, null, false); // 해당 접속 중에는 자동 저장을 취소하도록 정의
		sessionFactoryBean.setTransactionFactory(trn); // 생성한 트랜잭션 정보를 Mybatis에 전달

		return sessionFactoryBean.getObject();
	}

	@Bean @Qualifier("sql1")
	public SqlSession sql1(@Qualifier("sqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
		return new SqlSessionTemplate(sqlSessionFactory); // 사용 후 자동 종료 하는 섹션
	}


	@Bean @Qualifier("sql2")
	public SqlSession sql2(@Qualifier("sqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
		return sqlSessionFactory.openSession(false); // 하나의 섹션 사용하기 위해서 생성
	}

}
