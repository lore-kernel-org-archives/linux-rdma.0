From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: CQ overrun with ib_send_bw
Date: Fri, 13 Aug 2010 12:14:38 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96887A2@orsmsx501.amr.corp.intel.com>
References: <4C659288.4030402@oracle.com>
 <1281726396.2313.44.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281726396.2313.44.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Sumeet Lahorani <Sumeet.Lahorani-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I know there is a bug with "ib_send_bw -b" (bi-directional)
> since it doesn't create a CQ that is large enough for all the
> posted sends *and* receives.  I have tried several times to get the
> following patch applied but I never got a reply and nothing was
> done.

Who's the maintainer of these tests?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
