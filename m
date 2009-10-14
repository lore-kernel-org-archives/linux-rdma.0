From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 3/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 14:08:01 -0700
Message-ID: <4AD63DB1.3060906@mellanox.com>
References: <4AD3B453.3030109@mellanox.com> <ada1vl5alqh.fsf@cisco.com>	<4AD63681.6080901@mellanox.com> <adaljjd8zrj.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaljjd8zrj.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>  > First it does not make sense for user to set it below 60; therefore,
>  > it is forced to have 60 and above
>
> Why not?  A minute seems to be a really long time given the point of
> these patches is supposed to be failing over faster.  Surely we can tell
> if a path really failed sooner than 60 seconds on an IB fabric.
>
>  - R.
>   
When we fail-over, it will cause the luns ownership transfer in 
target/storage. It's undesirable op unless necessary
Target/storage most likely can reboot and come back within 60 seconds
We don't want to create the situation of path bouncing

-vu
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
