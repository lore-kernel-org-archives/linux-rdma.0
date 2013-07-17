From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Wed, 17 Jul 2013 13:57:37 -0400
Message-ID: <51E6DB11.9050906@redhat.com>
References: <1372768306-6786-1-git-send-email-jsquyres@cisco.com> <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA@mail.gmail.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6@xmb-rcd-x01.cisco.com> <CAL1RGDU+4CSJyF0TAfAv-YYcjA4FG+XNeg5pGCHPeW5iqhvwpA@mail.gmail.com> <20130708172621.GA3852@obsidianresearch.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F70BF83@xmb-rcd-x01.cisco.com> <1828884A29C6694DAF28B7E6B8A82373805AAB74@ORSMSX109.amr.corp.intel.com> <20130716144747.GA7304@obsidianresearch.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F7211E6@xmb-rcd-x01.cisco.com> <CAL1RGDWKmecLXsqphwdP9XG=4Y=65Z_ACSdRBhEqVQb6Q4LrUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWKmecLXsqphwdP9XG=4Y=65Z_ACSdRBhEqVQb6Q4LrUg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/16/2013 08:16 PM, Roland Dreier wrote:
> On Tue, Jul 16, 2013 at 10:11 AM, Jeff Squyres (jsquyres)
> <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>> - doing it this way preserves ABI, so existing binaries are safe
> 
> I still don't get this.  Wouldn't an existing binary be pretty
> surprised to get a value wildly out of range of the enum?

Yes, but there's no way around that without simply lying about the MTU.
 So, the argument was made in the thread that historically, applications
have had to be modified when moved to a new link layer (aka, iWARP meant
IB apps had to be slightly modified for connection reasons, RoCE again
required some slight app modifications, etc) so this was seen as a case
of "the app will work on fabrics it already knows about, and will only
get confused if moved to this new fabric, and in that case, the app
needs to be modified anyway, so that's acceptable breakage for keeping
the apps working the rest of the time".  That was the argument anyway.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
