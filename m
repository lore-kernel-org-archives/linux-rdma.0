From: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: Re: [PATCH v2] mlx4: properly mask MGM entry members count
Date: Wed, 1 Dec 2010 10:35:18 +0200
Message-ID: <AANLkTi=CsLOR8e1Dbshw__jnO5zM=Dyv7AToUF=V8Pq+@mail.gmail.com>
References: <20101116181520.GA29609@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101116181520.GA29609@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 16, 2010 at 8:15 PM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wro=
te:
> The members_count field size is 24 bits so mask it properly when read=
ing it.
>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> ---

>
> - =C2=A0 =C2=A0 =C2=A0 members_count =3D be32_to_cpu(mgm->members_cou=
nt);
> + =C2=A0 =C2=A0 =C2=A0 members_count =3D be32_to_cpu(mgm->members_cou=
nt) & 0xffffff;



Later,  in attach/detach you are loosing protocol when assigning
mgm->members_count.

line:
mgm->members_count =3D cpu_to_be32(members_count)

should be changes to:
mgm->members_count =3D cpu_to_be32(members_count) | (mgm->members_count
& 0xff000000);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
