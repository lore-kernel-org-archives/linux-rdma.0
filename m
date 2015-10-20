From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating
 AH from WC
Date: Tue, 20 Oct 2015 15:57:54 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A9736832@ORSMSX109.amr.corp.intel.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
	<1444568298-17289-2-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734356@ORSMSX109.amr.corp.intel.com>
	<CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734A57@ORSMSX109.amr.corp.intel.com>
	<CAAKD3BAF763brdhsrHtpm_peHk--g3iza53AioiUefepHM_s2w@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A9735914@ORSMSX109.amr.corp.intel.com>
 <CAAKD3BCdbD8MC4PJGuVzUxiq5wEbCNjX4e91vBkcoErJVM8FQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BCdbD8MC4PJGuVzUxiq5wEbCNjX4e91vBkcoErJVM8FQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

PiBUb2RheSwgY20gYXNzdW1lcyBwYXRocyBhcmUgcmV2ZXJzaWJsZSBwcmltYXJ5X3BhdGgtPnJl
dmVyc2libGUgPSAxLg0KDQpJIGNhbid0IHF1aWNrbHkgZmluZCBhIGxpbmssIGJ1dCBJIGJlbGll
dmUgYWxsIENNIE1BRHMgYXJlIHJldmVyc2libGUsIHBlciB0aGUgc3BlYy4NCg==
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
