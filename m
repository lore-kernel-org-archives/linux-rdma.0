From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma_core] redhat spec: Avoid conflict due to implicit
 directory add
Date: Mon, 13 Mar 2017 15:23:14 -0400
Message-ID: <861182f1-1d2a-2cdc-416f-bc0132201d47@redhat.com>
References: <9707bd97229b67fe04d29affcb37f61b80e20dca.1484143751.git-series.knut.omang@oracle.com>
 <20170313170829.GD25664@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170313170829.GD25664-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2017-03-13 1:08 PM, Jason Gunthorpe wrote:
> On Wed, Jan 11, 2017 at 03:19:34PM +0100, Knut Omang wrote:
>> If *-notation is used to include subdirectories, they
>> seem to end as explicit file additions. This causes conflicts
>> with other packages that provides the same
>> directories, in this case rdma_core-devel conflicts
>> with filesystem and kernel-headers.
>>
>> Using %dir did not seem to help
>> avoiding the issue but rather cause duplicate warnings, eg.
>>
>> warning: File listed twice: /usr/include/infiniband
>>
>> This should be considered a bug in rpmbuild but
>> probably needs to be fixed here anyway:
>>
>> List each individual directory with wildcards
>> to avoid the issue.
>>
>> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>  redhat/rdma-core.spec | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Did this ever get settled?
>
> Jarod? Yes/No?

Sorry, missed this. I don't remember ever hitting this myself, but the 
change looks benign enough, so sure, why not.


-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
