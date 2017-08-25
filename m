From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCHv2 rdma-core 5/5] cbuild: use SUSE spec file for SUSE
 targets
Date: Fri, 25 Aug 2017 09:16:51 -0600
Message-ID: <20170825151651.GB1027@obsidianresearch.com>
References: <88926674-d707-6f00-e9a1-e2a823fec323@suse.de>
 <6173036c-1120-3afa-274d-8b41ce821da2@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6173036c-1120-3afa-274d-8b41ce821da2-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 25, 2017 at 12:40:14PM +0200, Nicolas Morey-Chaisemartin wrote:
> Signed-off-by: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
>  buildlib/cbuild | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/buildlib/cbuild b/buildlib/cbuild
> index 86a5e42d..4c3ef36b 100755
> +++ b/buildlib/cbuild
> @@ -293,6 +293,7 @@ class ZypperEnvironment(Environment):
>  
>  class leap(ZypperEnvironment):
>      docker_parent = "opensuse:42.2";
> +    specfile = "suse/rdma-core.spec";
>      pkgs = {
>          'cmake',
>          'gcc',
> @@ -313,6 +314,7 @@ class tumbleweed(ZypperEnvironment):
>      docker_parent = "opensuse:tumbleweed";
>      pkgs = leap.pkgs;
>      name = "tumbleweed";
> +    specfile = "suse/rdma-core.spec";
>  
>  # -------------------------------------------------------------------------

Would you add another patch to delete the top level rdma-core.spec
please?

Nothing uses it now.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
