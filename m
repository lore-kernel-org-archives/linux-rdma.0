From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma_core] redhat spec: Avoid conflict due to implicit
 directory add
Date: Tue, 14 Mar 2017 08:10:49 +0100
Message-ID: <1489475449.10153.201.camel@oracle.com>
References: <9707bd97229b67fe04d29affcb37f61b80e20dca.1484143751.git-series.knut.omang@oracle.com>
         <20170313170829.GD25664@obsidianresearch.com>
         <861182f1-1d2a-2cdc-416f-bc0132201d47@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <861182f1-1d2a-2cdc-416f-bc0132201d47-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-13 at 15:23 -0400, Jarod Wilson wrote:
> On 2017-03-13 1:08 PM, Jason Gunthorpe wrote:
> > 
> > On Wed, Jan 11, 2017 at 03:19:34PM +0100, Knut Omang wrote:
> > > 
> > > If *-notation is used to include subdirectories, they
> > > seem to end as explicit file additions. This causes conflicts
> > > with other packages that provides the same
> > > directories, in this case rdma_core-devel conflicts
> > > with filesystem and kernel-headers.
> > > 
> > > Using %dir did not seem to help
> > > avoiding the issue but rather cause duplicate warnings, eg.
> > > 
> > > warning: File listed twice: /usr/include/infiniband
> > > 
> > > This should be considered a bug in rpmbuild but
> > > probably needs to be fixed here anyway:
> > > 
> > > List each individual directory with wildcards
> > > to avoid the issue.
> > > 
> > > Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > >  redhat/rdma-core.spec | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Did this ever get settled?
> > 
> > Jarod? Yes/No?
> 
> Sorry, missed this. I don't remember ever hitting this myself, but the 
> change looks benign enough, so sure, why not.

Yes, and now I think I finally understand why you have not hit it:
It seems to work as expected with a lot of different ways of invoking
rpmbuild, but for some subtle reason, not the way I have been using in a script
for years, and I still don't understand why. 

This is probably again more of an rpmbuild issue but still it might be something
that others have run into as well.

Instead of doing like eg. fedpkg is doing: providing a lot of elaborous (and
quite ugly IMHO)  --define '_sourcedir ...' --define '_specdir ...' ..  on the
command line to rpmbuild, I wanted to be able to just have a macro file
prepended at the end of the macro path - the file can then have a nice, clean
content like:

%_sourcedir ...
%_specdir ...
...

However there is no way I have figured to specify an additional element to the
macros path - the only way is to use --macros which overloads the complete path.
So my script initially run rpmbuild .. --showrc and picks up the default macro
path and prepends it with the extra element, a solution not perfect, but that
gave me some satisfaction over having beaten rpmbuild back when I wrote the code
:-)

For some obscure reason this now produces different behaviour. 
Any light on this appreciated - this has caused me a lot of grief...

Thanks,
Knut

> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
