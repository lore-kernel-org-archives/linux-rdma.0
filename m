From: "faibish, sorin" <faibish_sorin-mb1K0bWo544@public.gmane.org>
Subject: Re: Proposal for simplifying NFS/RDMA client memory registration
Date: Mon, 3 Mar 2014 14:54:13 -0500
Message-ID: <79E85B7D-5ECC-4A63-BB07-C45A570DA53D@emc.com>
References: <01C4496A-F074-4F72-9DF0-6076C05E8A1F@oracle.com>
 <E755E683-C064-4ED3-8448-C61F4E5AF16E@oracle.com>
 <20140303190733.GA4556@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140303190733.GA4556-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Sent from my iPad

> On Mar 3, 2014, at 7:09 PM, "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
>> On Mon, Mar 03, 2014 at 12:02:33PM -0500, Chuck Lever wrote:
>> All HCAs in 3.13 (and rxe) can support either MTHCA_FMR or FRMR or both. Wendy?s HCA supports only ALLPHYSICAL.
> 
> Is Wendy planning to submit her HCA driver ASAP?  If not there's not
> reason to keep ALLPHYSICAL either.
I second Christoph. Legacy is good as long as there are users of Linux with the legacy server. I would say that the only reason to keep it is if Linux server will support it. Same we apply to Lustre client in kernel.

./Sorin

> 
>> Does it make sense to deprecate then remove the registration modes in the first list?
> 
> Yes.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
