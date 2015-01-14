From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH FIX for-3.19] IB/ipoib: Fix failed multicast joins/sends
Date: Wed, 14 Jan 2015 11:54:49 +0200
Message-ID: <54B63CE9.3080205@mellanox.com>
References: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c903a4f1282f7d5852157c68bcc3f4324fd4300f.1421217352.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/14/2015 8:38 AM, Doug Ledford wrote:
> The usage of IPOIB_MCAST_RUN as a flag is inconsistent.  In some places
> it is used to mean "our device is administratively allowed to send
> multicast joins/leaves/packets" [...]
what? please tell which of these upstream hits (prior to any fix) has 
this semantics?

# git grep -n IPOIB_MCAST_RUN drivers/infiniband/ulp/ipoib
drivers/infiniband/ulp/ipoib/ipoib.h:90: IPOIB_MCAST_RUN           = 6,
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:434: if 
(test_bit(IPOIB_MCAST_RUN, &priv->flags))
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:466:     if (status && 
test_bit(IPOIB_MCAST_RUN, &priv->flags))
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:536: if 
(test_bit(IPOIB_MCAST_RUN, &priv->flags))
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:550:     if 
(!test_bit(IPOIB_MCAST_RUN, &priv->flags))
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:576: if 
(test_bit(IPOIB_MCAST_RUN, &priv->flags))
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:634: 
clear_bit(IPOIB_MCAST_RUN, &priv->flags);
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:644:     if 
(!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:658: 
clear_bit(IPOIB_MCAST_RUN, &priv->flags);
drivers/infiniband/ulp/ipoib/ipoib_multicast.c:728: if 
(!test_and_set_bit(IPOIB_MCAST_RUN, &priv->flags))

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
