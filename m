From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: IB/ocrdma: Improve size determinations in ten functions
Date: Mon, 24 Apr 2017 15:23:52 +0200
Message-ID: <a2b014f3-7674-6e33-3b22-72594b38a6b6@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
 <1492720999.3041.18.camel@redhat.com>
 <86425035-7da8-d2b1-8544-d4f7540d50c6@users.sourceforge.net>
 <755f6c2c-03a2-7248-a5e3-9190d119cdaf@users.sourceforge.net>
 <20170423073311.GA14088@mtr-leonro.local>
 <1f122892-7e67-a7ca-ae7f-7ac8e2b7a037@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1f122892-7e67-a7ca-ae7f-7ac8e2b7a037@intel.com>
Content-Language: en-GB
Sender: kernel-janitors-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Devesh Sharma <devesh.sharma@avagotech.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> Markus, what have you done to ensure your patches don't break anything?

I would expect that this update step will not change the run time behaviour
for the OCRDMA module. I guess that it will influence the run time
characteristics for compilation of three adjusted source files besides
the proposed coding style improvements.

Further update steps change other source code places. I hope that their
impact can be clarified according to your expectations for each shown update
possibility separately. Some of them got a bit of acceptance already.

How would you like to reduce any remaining software development concerns here?

Regards,
Markus
