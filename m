From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH RFC] iser-target: avoid reinitializing rdma contexts for
 isert commands
Date: Mon, 4 Dec 2017 20:31:14 +0200
Message-ID: <b0a79c32-6820-e3ab-325d-43f0c1b3a839@grimberg.me>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
 <349dba5f-dbed-164e-5c7a-d22ae929dbfc@grimberg.me>
 <20171130103450.GA4185@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20171130103450.GA4185@chelsio.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Potnuri Bharat Teja <bharat@chelsio.com>
Cc: "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> Hi Sagi,
> Thanks for the review.
> The post recv duplication is already handled as a part of "Queue full response
> handling" changes, Here is the patch that handles it:
> https://patchwork.kernel.org/patch/9639185/

Right, forgot about that.

So looks fine to me,

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
