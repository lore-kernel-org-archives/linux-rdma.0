From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Fwd: [PATCH] svcrdma: Do not send XDR roundup bytes for a write
 chunk
Date: Thu, 12 Nov 2015 11:30:40 -0700
Message-ID: <20151112183040.GC25178@obsidianresearch.com>
References: <20151112144433.13507.34603.stgit@klimt.1015granger.net>
 <648A8847-9836-42EC-9D62-77C01C6E9ACF@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <648A8847-9836-42EC-9D62-77C01C6E9ACF-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 12, 2015 at 09:47:13AM -0500, Chuck Lever wrote:
> I wish git send-mail had an address book. I=E2=80=99m really tired
> of misspelling the to/cc addresses on patches.

It does:

CONFIGURATION
       sendemail.aliasesfile
           To avoid typing long email addresses, point this to one or m=
ore email aliases files. You must also supply
           sendemail.aliasfiletype.

       sendemail.aliasfiletype
           Format of the file(s) specified in sendemail.aliasesfile. Mu=
st be one of mutt, mailrc, pine, elm, or gnus.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
