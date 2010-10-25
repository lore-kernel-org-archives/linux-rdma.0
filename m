From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH management.git] Fix autotools to include the necessary
 M4 files
Date: Mon, 25 Oct 2010 20:27:15 +0200
Message-ID: <20101025182715.GF14919@me>
References: <20101007223301.GA30829@obsidianresearch.com>
 <20101025180556.GD14919@me>
 <20101025181451.GE15514@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101025181451.GE15514-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:14 Mon 25 Oct     , Jason Gunthorpe wrote:
> 
> vs after patching:
> 
> jggl{jgg}/tmp/ofa/management/libibumad#./autogen.sh 
> + aclocal -I config
> + libtoolize --force --copy
> libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `config'.
> libtoolize: copying file `config/ltmain.sh'
> libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `config'.
> libtoolize: copying file `config/libtool.m4'
> libtoolize: copying file `config/ltoptions.m4'
> libtoolize: copying file `config/ltsugar.m4'
> libtoolize: copying file `config/ltversion.m4'
> libtoolize: copying file `config/lt~obsolete.m4'
> + autoheader
> + automake --foreign --add-missing --copy
> + autoconf
> 
> Much happier.

Ok. I see now.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
