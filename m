From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 01/10] svcrdma: Do not write xdr_buf::tail in a Write chunk
Date: Mon, 22 Feb 2016 13:39:07 -0500
Message-ID: <01D1023C-687F-46A1-98B3-2135F471B0D4@oracle.com>
References: <20160218173840.12825.26769.stgit@klimt.1015granger.net> <20160218174353.12825.14732.stgit@klimt.1015granger.net> <20160222183211.GA22270@fieldses.org> <EF7CD34B-53D8-4657-938C-F19DD5A5A666@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF7CD34B-53D8-4657-938C-F19DD5A5A666-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Feb 22, 2016, at 1:35 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> 
>> On Feb 22, 2016, at 1:32 PM, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org wrote:
>> 
>> On Thu, Feb 18, 2016 at 12:43:53PM -0500, Chuck Lever wrote:
>>> The fix is to send only the contents of the xdr_buf's page list in
>>> a Write chunk.
>> 
>> This isn't quite right either.  A large-enough non-readlike reply will
>> use the page list if that's the only way to fit the reply.
>> 
>> You might be able to hit such cases, for example, using nfs4_getfacl on
>> a file with a sufficiently large ACL.
> 
> Clients provide a write chunk only for READ and READLINK.
> No way to hit this with GETFACL unless the client is doing
> something wrong.

OK, I see your point: and yes, I agree. The next revision
of the patch is more careful about trimming the page list
pad _only_ for the write chunk case, not for the reply case,
which is what you hit with GETFACL.


> Anyway, I've got another revision of this work coming, this
> time it should be a complete fix.
> 
> Thanks as always for your careful review!
> 
> --
> Chuck Lever
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
