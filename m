From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Query regarding which tree to use to create upstream patches
Date: Fri, 14 Oct 2011 10:35:46 -0700
Message-ID: <CAL1RGDVWCmSb5JMZEssAQ8Y_OQSiy-OgRmc1mkk9NRgz2XPDhQ@mail.gmail.com>
References: <8A71B368A89016469F72CD08050AD3340A3D28AE@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8A71B368A89016469F72CD08050AD3340A3D28AE-utt48SW1nMZEErodcbzraFjMPmZJtkid@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Kumar A S <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Dimitrios Michailidis <dm-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2011 at 8:54 AM, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote=
:
> 1) We make our patch series against 'linux-next' tree (which has
> =91drivers/net=92 directory changes and latest changes from =91infini=
band=92 tree)
> and submit them to you and you can accordingly decide when to merge t=
hem in
> your tree.

This seems fine.  I can review the patches, and then merge them for
upstream once net-next hits Linus's tree.

(I assume the cxgb4 net driver changes are already in net-next for 3.2?=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
