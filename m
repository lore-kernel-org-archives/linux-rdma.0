From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx4 catas_reset hangs when using the CM
Date: Fri, 30 Mar 2012 11:33:56 -0700
Message-ID: <CAL1RGDV-j7A7vEXuWkK6Q96u09woB2vx92gp9LS2=uWFrDmCbw@mail.gmail.com>
References: <20120329134110.0683d873@b012350-ux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120329134110.0683d873@b012350-ux>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vincent <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, Celine <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 29, 2012 at 4:41 AM, sebastien dugue
<sebastien.dugue-6ktuUTfB/bM@public.gmane.org> wrote:
> =A0So it looks like that cma_process_remove() did all it's job cleani=
ng up
> but is hung waiting for the client refcount to reach 0, which never h=
appens.

This is unfortunately expected with the current implementation.  Becaus=
e we
don't have a way to revoke active userspace users of the device, we jus=
t send
them a catastrophic error async event and then expect them to clsoe the
device.  But if they never close the device, we just wait forever.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
