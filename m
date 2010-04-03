From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] infiniband: potential double free
Date: Sun, 4 Apr 2010 01:34:29 +0300
Message-ID: <q2x15ddcffd1004031534p4483d916i595434a12dfd7696@mail.gmail.com>
References: <20100315082332.GF18181@bicker>
	 <20100315141846.GA1477@holoscopio.com> <20100315150735.GM18181@bicker>
	 <15ddcffd1003160027q47286fcqa1344c964fe472b0@mail.gmail.com>
	 <20100316080925.GC5331@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100316080925.GC5331@bicker>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo-DmMZpsCg3uxeGPcbtGPokg@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 16, 2010 at 10:09 AM, Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> We shouldn't free things here because we free them later. =A0The call=
 tree looks like this:


Hi Dan, Roland,

We're at a somehow high holiday (e.g Passover) season, and as such I
haven't resolve the issue Dan brought yet. However, all in all this is
--not-- a regression but rather a bug in the error handling code of a
path (synchronous connection establishment) which isn't used (e.g
non_blocking is always true when called by the iscsi stack).

I will make sure to fix the issue for the next merge window, and
actually queue a fixed/reviewed patch (e.g review what Dan works on)
way before that. So in that respect, Roland, you need not to deal with
this directly. Please make sure to cc  linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on
each related mail, thanks

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
