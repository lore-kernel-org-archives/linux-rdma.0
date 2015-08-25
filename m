From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/ipoib: Suppress warning for send only join failures
Date: Tue, 25 Aug 2015 08:59:13 -0400
Message-ID: <55DC66A1.9040207@dev.mellanox.co.il>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com> <1440200053-18890-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440200053-18890-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/21/2015 7:34 PM, Jason Gunthorpe wrote:
> We expect send only joins to fail, it just means there are no listeners
> for the group. The correct thing to do is silently drop the packet
> at source.
> 
> Eg avahi will full join 224.0.0.251 which causes a send only IGMP packet
> to 224.0.0.22, and then a warning level kmessage like this:
> 
>  ib0: sendonly multicast join failed for ff12:401b:ffff:0000:0000:0000:0000:0016, status -22
> 
> If there is no IP router listening to IGMP.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index c0e702c577d5..2d43ec542b63 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -393,8 +393,13 @@ static int ipoib_mcast_join_complete(int status,
>  			goto out_locked;
>  		}
>  	} else {
> -		if (mcast->logcount++ < 20) {
> -			if (status == -ETIMEDOUT || status == -EAGAIN) {
> +		bool silent_fail =
> +		    test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&
> +		    status == -EINVAL;

Aren't there other reasons that send only join might have EINVAL
indicated ? Maybe it's better to be overly silent rather than overly
verbose as to not spam the log but it seems like it would make debug of
such cases harder.

> +
> +		if (mcast->logcount < 20) {
> +			if (status == -ETIMEDOUT || status == -EAGAIN ||
> +			    silent_fail) {
>  				ipoib_dbg_mcast(priv, "%smulticast join failed for %pI6, status %d\n",
>  						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
>  						mcast->mcmember.mgid.raw, status);

ipoib_dbg_mcast logging is conditionalized on CONFIG_INFINIBAND_IPOIB_DEBUG

> @@ -403,6 +408,9 @@ static int ipoib_mcast_join_complete(int status,
>  						test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) ? "sendonly " : "",
>  					   mcast->mcmember.mgid.raw, status);
>  			}
> +
> +			if (!silent_fail)
> +				mcast->logcount++;
>  		}
>  
>  		if (test_bit(IPOIB_MCAST_FLAG_SENDONLY, &mcast->flags) &&

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
