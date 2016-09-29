From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: rdma-core: cmake minimum version issue on RH 6.5
Date: Thu, 29 Sep 2016 14:40:30 +0300
Message-ID: <5169a490-10b4-cb9f-d7b7-fb552692f1f6@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

Currently there is a hard requirement of cmake minimum version of 2.8.11 
to build the rdma-core project. (i.e. cmake_minimum_required(VERSION 
2.8.11 ATAL_ERROR)).


Trying to build with default yum install of cmake on RH6.5 fails as it 
doesn't meet the above requirement. (i.e. cmake version 2.6-patch 4).

As a test phase, we tried to comment out this limitation from the cmake 
files, however, the build failed with few other errors. (e.g. CMake 
Error at buildlib/rdma_functions.cmake:39 (set_property):
set_property could not find TARGET APPEND_STRING. Perhaps it has not yet
been created).

Is it a real requirement for above cmake minimum version in this project 
? if yes, where the appropriate cmake should come from to work on RH6.5.

Yishai


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
