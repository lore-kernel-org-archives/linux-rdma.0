From: Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/2] rdma/ib: Add trace point macros to display
 human-readable values
Date: Tue, 23 Jan 2018 11:42:43 -0500
Message-ID: <9414965c-f3e7-b704-a022-a337b07254c6@Netapp.com>
References: <20180120161440.6488.4311.stgit@manet.1015granger.net>
 <20180120161625.6488.7416.stgit@manet.1015granger.net>
 <20180122174709.GE14372@ziepe.ca>
 <A6F9729C-9922-4C9D-9264-F053DB76B622@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A6F9729C-9922-4C9D-9264-F053DB76B622-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 01/23/2018 11:38 AM, Chuck Lever wrote:
> 
> 
>> On Jan 22, 2018, at 9:47 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>>
>> On Sat, Jan 20, 2018 at 11:16:25AM -0500, Chuck Lever wrote:
>>> These can be shared with all kernel ULPs, and more can easily be
>>> added as needed.
>>>
>>> Note: checkpatch.pl has some heartburn with the TRACE_DEFINE_ENUM
>>> macros and the LIST macros. These follow the same style as other
>>> header files under include/tracing/events , thus should be
>>> considered acceptable exceptions.
>>>
>>> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> include/trace/events/rdma.h |  129 +++++++++++++++++++++++++++++++++++++++++++
>>> 1 file changed, 129 insertions(+)
>>> create mode 100644 include/trace/events/rdma.h
>>
>> Not knowing a lout about trace points, this does seem OK to me:
>>
>> Acked-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> To flow through Anna's tree
> 
> Thanks, Jason.

Thank you!  I've added the patches to my tree.
> 
> --
> Chuck Lever
> 
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
