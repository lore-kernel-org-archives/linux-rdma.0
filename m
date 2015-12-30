From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re:
 git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git/k.o/for-4.5
 crash during boot
Date: Wed, 30 Dec 2015 14:34:28 +0200
Message-ID: <20151230123428.GB10271@leon.nu>
References: <5683C863.4040209@sandisk.com>
 <5683CC7F.5020301@mellanox.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5683CC7F.5020301-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 30, 2015 at 02:22:23PM +0200, Or Gerlitz wrote:
> On 12/30/2015 2:04 PM, Bart Van Assche wrote:
> >Hello Christoph,
> >
> >Can you check whether the branch in the subject of this e-mail works fine
> >on your setup (commit 59caaed7a7) ? On my test setup (Dell R430 with two
> >ConnectX-3 adapters) this branch crashes during boot in
> >get_counter_table() (see also the attached screenshot).
> 
> Can you please check with Hal's fix that was posted here 1-2 days ago,
> hopefully this should make your system to work

Or referenced to this patch [1], it should fix your crash.

[1] https://patchwork.kernel.org/patch/7929551/

> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
