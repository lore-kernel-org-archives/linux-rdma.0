From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 4/4] IB/uverbs: Support for associating XRC domains to inodes
Date: Thu, 4 Feb 2010 11:29:43 +0200
Message-ID: <201002041129.43938.jackm@dev.mellanox.co.il>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com> <201002011552.24904.jackm@dev.mellanox.co.il> <adaeil2gfy9.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaeil2gfy9.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wednesday 03 February 2010 23:35, Roland Dreier wrote:
> =A0> 2. In closing/deallocating xrc domains, it is not an error if ib=
_dealloc_xrcd returns "busy".
> =A0> =A0 =A0This simply means that there are other user processes sti=
ll using that xrc domain.
> =A0> =A0 =A0The current process still needs to clean up its uobject. =
=A0In particular, the usecnt should
> =A0> =A0 =A0not be re-incremented on the busy return. (If it gets re-=
incremented on busy, no one can ever
> =A0> =A0 =A0succeed in closing an xrc domain if more that one process=
 is using it).
>=20
> I do agree we shouldn't reincrement the use count if the dealloc
> fails -- in ib_uverbs_dealloc_xrcd we're in the path of closing a
> context and so there's no real way to recover if the ib_dealloc_xrcd
> fails.

Agreed.  If we return an error when there is no i-node, then we should =
also return an error when
an i-node exists (and restore the status-quo-ante by reincrementing the=
 refcnt in this case).
Although, this will leave things in a weird state (with an xrcd which c=
annot get deallocated).
Like you, I don't really see other options here.

> But I don't think the busy case is an issue -- we should return=20
> without trying to dealloc if the xrcd is held by another process, sin=
ce
> the atomic_dec_and_test will return a non-zero value in that case I
> think.
You are correct -- I missed that in my review.

> So the simplification in the patch below should be OK, right?=20
Looks good!

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
