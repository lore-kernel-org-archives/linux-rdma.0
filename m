From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: building rdma-core from travis
Date: Tue, 18 Oct 2016 00:06:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB096A91@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB096A7B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB096A7B-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> CMake Error at CMakeLists.txt:23 (cmake_minimum_required):
> 
>   CMake 2.8.11 or higher is required.  You are running version 2.8.7
> 
> 
> I can see that travis runs successfully against rdma-core.  Was there a
> magic setting used to work-around the travis version?

It looks like rdma-core requires the 'trusty' build on travis...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
