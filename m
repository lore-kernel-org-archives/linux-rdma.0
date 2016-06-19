From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/24] mlx4-ib: Use coherent memory for priv pages
Date: Sun, 19 Jun 2016 22:38:53 +0300
Message-ID: <CAJ3xEMha=i5SaM+fV5XP15Fx6pymrYnvk=a8w+3h1cbBeuVX0A@mail.gmail.com>
References: <20160615030626.14794.43805.stgit@manet.1015granger.net>
 <20160615031525.14794.69066.stgit@manet.1015granger.net> <20160615042849.GR5408@leon.nu>
 <68F7CD80-0092-4B55-9FAD-4C54D284BCA3@oracle.com> <20160616143518.GX5408@leon.nu>
 <576315C9.30002@gmail.com> <652EBA09-2978-414C-8606-38A96C63365A@oracle.com>
 <20160617092018.GZ5408@leon.nu> <4D23496A-FE01-4693-B125-82CD03B8F2D4@oracle.com>
 <20160618105650.GD5408@leon.nu> <5D0A6B47-CB71-42DA-AE76-164B6A660ECC@oracle.com>
 <57666E14.2070802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57666E14.2070802-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 19, 2016 at 1:04 PM, Sagi Grimberg <sagigrim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>> I am able to reproduce the Local Protection Errors with
>> this patch applied and SLUB debugging disabled.

> Thanks Chuck for proving that the dma alignment is not the issue here.
>
> I suggest that we go with my dma coherent patch for now until Leon and
> the Mellanox team can debug this one with the HW/FW folks and find out
> what is going on.
>
> Leon, I had my share of debugging this area on mlx4/mlx5 areas. If you
> want I can help with debugging this one.

Hi Sagi, Leon and Co,

>From quick reading of the patch I got the impression that some scheme
which used to work is now broken, did we get a bisection result
pointing to the upstream commit which introduce the regression? I
didn't see such note along the thread, basically, I think this is
where we should be starting, thoughts? I also added the mlx4 core/IB
maintainer.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
