From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/6] rdmacm: Use C11 stdatomic for all atomics
Date: Wed, 15 Mar 2017 22:55:52 +0000
Message-ID: <1489618538.2660.14.camel@sandisk.com>
References: <1489615927-12117-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1489615927-12117-5-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489615927-12117-5-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <378CDD1EB9D9FB4EBD5328D4ACFD754E-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-15 at 16:12 -0600, Jason Gunthorpe wrote:
> @@ -1013,7 +1012,7 @@ int close(int socket)
>  			return ret;
>  	}
> =20
> -	if (atomic_dec(&fdi->refcnt))
> +	if (atomic_fetch_sub(&fdi->refcnt, 1))
>  		return 0;
> =20
>  	idm_clear(&idm, socket);
> @@ -898,7 +898,7 @@ static int rs_create_ep(struct rsocket *rs)
> =20
>  static void rs_release_iomap_mr(struct rs_iomap_mr *iomr)
>  {
> -	if (atomic_dec(&iomr->refcnt))
> +	if (atomic_fetch_sub(&iomr->refcnt, 1))
>  		return;
> =20
>  	dlist_remove(&iomr->entry);

Hello Jason,

In the gcc documentation I read that __sync_sub_and_fetch() (used to
implement atomic_dec()) returns the new value. In the C11 standard I read
that atomic_fetch_sub() returns the old value. Do you agree with this?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
