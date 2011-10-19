From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Wed, 19 Oct 2011 19:56:27 +0200
Message-ID: <CAO+b5-orW-iK6WiGAt8Ovd1g64e628tcOh13D5xA67SfJ-W-Vg@mail.gmail.com>
References: <1318556901-14850-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318556901-14850-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2011 at 3:48 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> This patch adds the kernel module ib_srpt SCSI RDMA Protocol (SRP) target
> implementation conforming to the SRP r16a specification for the mainline
> drivers/target infrastructure as requested by Christoph for an initial
> v3.2-rc1 merge.

Issues that have been fixed in the SCST source tree but not yet in the
LIO source tree:
- Handling error completions for failed multipart RDMA transfers
causes trouble (fixed in r3632 in the SCST repository).
- srpt_map can cause memory corruption (fixed in r3262 in the SCST repository).

Issues introduced in the LIO source tree:
- Using 128 bits for identifying a port seems overkill to me - 64 bits
is sufficient. Also, there is no guarantee that the formula used for
computing the port GID (node GUID + port number) will match the port
GID.
- srpt_make_nodeacl() returns 0 instead of an error code if
srpt_alloc_fabric_acl() fails.
- The headers of srpt_make_tport() and srpt_drop_tport() should be
updated such that these read "$driver/$port" instead of
"$driver/$target".

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
