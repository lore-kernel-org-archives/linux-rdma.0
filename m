From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 3/6] IB/mlx4: Fix parameter checking in create_cq
Date: Fri, 11 May 2012 10:39:12 +0300
Message-ID: <CAJZOPZLYp87tgMOBmaJGA4VqdH_t6=jAVr1o=Q7RJuVYZNethw@mail.gmail.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
	<1336681689-16668-4-git-send-email-ogerlitz@mellanox.com>
	<20120511091008.40d1dc3d@b012350-ux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511091008.40d1dc3d@b012350-ux>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org> wrote:
> > @@ -172,6 +172,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_devic=
e
> > *ibdev, int entries, int vector
> > =A0 =A0 =A0 struct mlx4_uar *uar;
> > =A0 =A0 =A0 int err;
> >
> > + =A0 =A0 entries =A0 =A0 =A0=3D roundup_pow_of_two(entries + 1);
> > =A0 =A0 =A0 if (entries < 1 || entries > dev->dev->caps.max_cqes)
>
> =A0Is the first check still needed here then?

not really, good catch - unless we need to protect here from negative
values coming
e.g from user space, I'll look this up,  thanks

Or.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
