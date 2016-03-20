From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sun, 20 Mar 2016 07:59:59 +0200
Message-ID: <20160320055959.GM25216@leon.nu>
References: <56EAE9D6.2030908@redhat.com>
 <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg@mail.gmail.com>
 <20160318173748.GL25216@leon.nu>
 <CA+55aFwNcyywn3gYQ=H_+6WMt=s+xZ5bgpX3O9z8b2o5EhDMGQ@mail.gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwNcyywn3gYQ=H_+6WMt=s+xZ5bgpX3O9z8b2o5EhDMGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Mar 19, 2016 at 02:37:08PM -0700, Linus Torvalds wrote:
> On Fri, Mar 18, 2016 at 10:37 AM, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org> wrote:
> > On Fri, Mar 18, 2016 at 09:52:16AM -0700, Linus Torvalds wrote:
> 
> So it requires a bit more care, and a bit more control. You need to be
> very confident about those shared commits that both the networking and
> rdma people take. But quite frankly, after the mess that has been
> Mellanox, that kind of care and effort just sounds like a good idea.
> 
> I hope that clarified.

Thank you for your such detailed explanation. It gave me a clear picture
on how to handle our future submissions.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
