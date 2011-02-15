From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] IPoIB: fix faulty list maintenance in path and neigh list
Date: Tue, 15 Feb 2011 10:24:27 -0800
Message-ID: <AANLkTin1pudSXZCGY31p2GnY6noWi2DS3y2+Gprj0+ug@mail.gmail.com>
References: <20110201161247.12671.10028.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110201161247.12671.10028.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gary.leshner-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, tom.elken-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm not sure I understand what this patch is trying to do.

> Added list_del to ipoib_mcast_free() and path_free() to remove the ne=
igh from
> the path's neigh_list link list before freeing the memory it consumes=
=2E
> This makes the code consistent with ipoib_cm_handle_tx_wc() and other=
 locations where the list_del() preceeds the call to ipoib_neigh_free()=
=2E

It looks like this is not needed -- in both cases, the code walks a
list of neigh
structs and frees them, and then frees the list itself a few lines
later.  So what
does it fix to delete the neigh structs from the list?

> Similarly, at list_del() now preceeds path_free() to remove the path =
from
> ipoib_dev_priv's path_list.

Similarly in ipoib_flush_paths() the code is walking a local remove_lis=
t that
is on the stack and will be thrown away when the function returns -- wh=
y does
it matter if we remove the paths from that list before freeing them?

> Additionally, the fields neigh->ah and neigh->list were not being ini=
tialized
> upon allocation. =A0The patch insures that these two remaining fields=
 are
> initialized correctly.

Again, I don't see how this fixes anything; neigh->list does not need t=
o be
initialized, since it is only used to add the neigh struct to other
lists (AFAICT).
And also AFAICT, every place that allocates a neigh always initializes =
neigh->ah
on every code path.  It might be cleaner to set neigh->ah to NULL but I=
 don't
see how this could fix something.

Pradeep seems to believe that this patch fixes some crashes but I would=
 like
to understand the real cause before blindly applying this patch.
Which part(s) are
the real fix, and what is the race or other bug it fixes?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
