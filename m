From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] RDS: Fix rds-ping inducing kernel panic
Date: Mon, 22 Jan 2018 10:47:30 -0500 (EST)
Message-ID: <20180122.104730.362327971778717733.davem@davemloft.net>
References: <20180122112415.GA41074@beast>
        <20180122151054.GJ1393@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180122151054.GJ1393@mtr-leonro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: leon@kernel.org
Cc: keescook@chromium.org, santosh.shilimkar@oracle.com, honli@redhat.com, linux-kernel@vger.kernel.org, sowmini.varadhan@oracle.com, sbeattie@ubuntu.com, apw@canonical.com, fenlason@redhat.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 22 Jan 2018 17:10:54 +0200

> On Mon, Jan 22, 2018 at 03:24:15AM -0800, Kees Cook wrote:
>> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
>> index 8557a1cae041..5fbf635d17cb 100644
>> --- a/net/rds/ib_send.c
>> +++ b/net/rds/ib_send.c
>> @@ -506,7 +506,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct rds_message *rm,
>>  	int flow_controlled = 0;
>>  	int nr_sig = 0;
>>
>> -	BUG_ON(off % RDS_FRAG_SIZE);
>> +	BUG_ON(!conn->c_loopback && off % RDS_FRAG_SIZE);
>>  	BUG_ON(hdr_off != 0 && hdr_off != sizeof(struct rds_header));
> 
> To be honest this function full of BUG_ONs and it looks fishy to have them there.
> Why don't we return EINVAL instead of crashing system?

I completely agree that these assertions should just cause an error-out
rather than trigger a BUG().
