From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] tests/subnet_discover: discover test utility
Date: Mon, 25 Jan 2010 17:18:47 +0200
Message-ID: <20100125151847.GM13519@me>
References: <20090826164026.8dcce4b2.weiny2@llnl.gov>
 <20091023234349.GK5764@me>
 <20091220121406.GF5262@me>
 <20091220182809.f7e17fae.weiny2@llnl.gov>
 <20091221073550.GB18524@me>
 <20091228092251.GR26940@me>
 <f0e08f231001110556y7c47cc54oa3cfd5859f9a4e76@mail.gmail.com>
 <20100112093145.GF26089@me>
 <f0e08f231001131211y64489a51nd2621cefdb27ad25@mail.gmail.com>
 <20100121123841.43df4cdc.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100121123841.43df4cdc.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 12:38 Thu 21 Jan     , Ira Weiny wrote:
> 
> Here is some test data on a real cluster.
> 
> 09:49:10 > ibhosts | wc -l
> 1158
> 
> 09:49:28 > ibswitches | wc -l
> 281
> 
> 09:44:45 > time ./subnet_discover -n 1 > /dev/null
> 
> real    0m1.414s
> user    0m0.309s
> sys     0m0.244s
> 
> 09:44:55 > time ./subnet_discover -n 2 > /dev/null
> 
> real    0m1.025s
> user    0m0.284s
> sys     0m0.201s
> 
> 09:45:00 > time ./subnet_discover -n 4 > /dev/null
> 
> real    0m0.644s
> user    0m0.268s
> sys     0m0.228s
> 
> 09:45:04 > time ./subnet_discover -n 8 > /dev/null
> 
> real    0m0.550s
> user    0m0.253s
> sys     0m0.184s
> 
> 09:45:08 > time ./subnet_discover -n 12 > /dev/null
> 
> real    0m0.524s
> user    0m0.207s
> sys     0m0.201s
> 
> 09:45:14 > time ./subnet_discover -n 16 > /dev/null
> 
> real    0m0.432s
> user    0m0.248s
> sys     0m0.144s

Looks like a very nice results. Thanks for probing this.

> 09:45:18 > time ./subnet_discover -n 32 > /dev/null
> 
> real    0m0.484s
> user    0m0.260s
> sys     0m0.150s

With '-n 32' the total time is increased. It is probably due to VL15
packets drops on switches. This can be ensured by checking VL15Drops
counter value. Also in this case using different from default timeout
values with ./subnet_discover (for example --timeout=1000 (default is
100ms)) will affect the total running time (this doesn't happen when
packets were not dropped and ib_mad retrying mechanism was not
activated).

> 09:45:57 > time ibnetdiscover  > /dev/null
> 
> real    0m3.180s
> user    0m0.068s
> sys     0m0.672s
> 
> 
> What I find most interesting is that your test utility runs nearly 2x faster
> even when there is only 1 outstanding MAD.  :-/  ibnetdiscover (libibnetdisc)
> does do a lot more with the data but I would not have expected such a
> difference.

Your fix for subnet_discover explains the difference.

> I would appear that your algorithm is superior.  I will look at converting
> libibnetdisc, test, and submit a patch.

Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
