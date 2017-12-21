From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Thu, 21 Dec 2017 09:21:41 -0600
Message-ID: <00be01d37a6f$676a88f0$363f9ad0$@opengridcomputing.com>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com> <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me> <018901d36d17$6a703410$3f509c30$@opengridcomputing.com> <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me> <018001d37917$a7d85e20$f7891a60$@opengridcomputing.com> <dc2589ef-b585-09be-c5d1-dce408b99d24@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <dc2589ef-b585-09be-c5d1-dce408b99d24@grimberg.me>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagi@grimberg.me>, 'target-devel' <target-devel@vger.kernel.org>
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> 
> 
> > Hey Sagi,
> >
> > I found my bug: If a wr chain is posted to iw_cxgb4  and needs to be flushed,
> only the first wr in the chain was being flushed.  The rest never completed.  This
> completion leak was causing the failure to deref IO commands...
> 
> Good to know,
> 
> Do does any of the other discussions in the thread still apply? Anything
> that I still need to look at?

At this point, no. 

Thanks for hanging in there with me. :)

Steve.
