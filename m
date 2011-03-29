From: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Subject: Re: Unable to Connect Using Active Speed 2.5 Gbps and Active Width of 1
Date: Tue, 29 Mar 2011 18:01:13 +0000 (UTC)
Message-ID: <loom.20110329T195143-723@post.gmane.org>
References: <loom.20110328T194956-774@post.gmane.org> <4D90D9A2.7000107@dev.mellanox.co.il> <loom.20110328T210350-244@post.gmane.org> <4D90DF38.1060407@dev.mellanox.co.il> <loom.20110328T212117-950@post.gmane.org> <20110328194150.GA6205@obsidianresearch.com> <loom.20110328T220853-101@post.gmane.org> <4D9218F0.3020000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock <hal@...> writes:
> 
> How about if rather than Test, you change it to Default=0x7fff ?
> 

I tried using the PKey since posting, but it alone did not solve the issue.

> 
> The above is pertinent to IPoIB ping but couldn't explain ibping lack of 
> connectivity.
> 

Turns out I was using the wrong port GUID (bad copy and paste) when testing with
ibping. It has been working all along.

I have just now solved the issue.

The partitions.conf file took me in the right direction.  The solution was to
use rate=2 instead of as rate=1 (which apparently is a reserved value).  I was
unable find documentation for the rate-value pairs, so I was assuming that
rate=1 was 2.5.  I finally found documentation for the rates in a post on the
old ofa-general mailing list:

#define IB_PATH_RECORD_RATE_2_5_GBS             2
#define IB_PATH_RECORD_RATE_10_GBS              3
#define IB_PATH_RECORD_RATE_30_GBS              4
#define IB_PATH_RECORD_RATE_5_GBS               5
#define IB_PATH_RECORD_RATE_20_GBS              6
#define IB_PATH_RECORD_RATE_40_GBS              7
#define IB_PATH_RECORD_RATE_60_GBS              8
#define IB_PATH_RECORD_RATE_80_GBS              9
#define IB_PATH_RECORD_RATE_120_GBS             10

#define IB_MIN_RATE    IB_PATH_RECORD_RATE_2_5_GBS
#define IB_MAX_RATE    IB_PATH_RECORD_RATE_120_GBS

Setting my partitions.conf as follows has solved the issue:

Default=0x7fff,ipoib,rate=2:ALL=full;

Thanks everyone for the help.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
