From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V4 for-next 0/4] Support SendOnlyFullMember join
Date: Mon, 16 May 2016 21:10:12 +0300
Message-ID: <CAAk-MO_CXmP+-WKbXpnFV=JaOu6Cspo3bGL0qwMJeoe3NoyTmQ@mail.gmail.com>
References: <1463401694-19247-1-git-send-email-erezsh@mellanox.com>
	<8e7686fa-de3e-1a92-1168-528909eb4019@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8e7686fa-de3e-1a92-1168-528909eb4019-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 16, 2016 at 6:45 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 05/16/2016 08:28 AM, Erez Shitrit wrote:
>> There are four types of multicast join: FullMember, NonMember,
>> SendOnlyNonMember and SendOnlyFullMember.
>>
>> This patch-set introduces the ability to send multicast join requests of
>> type SendOnlyFullMember (until now only the first three types were
>> supported).
>> Host that sends such join request, does not require a multicast
>> subscription and will still send properly, and in addition will not get
>> other multicast packets from that group.
>>
>> It adds a new SA query (for classport_info) to check that the sm
>> supports sending such requests and it modifies multicast processing in
>> the IB/core module to handle SendOnlyFullMember multicast join requests.
>>
>> In addition, the patch set modifies IPoIB so that if the sm does support
>> SendOnlyFullMember join requests, IPoIB will send such a request when
>> joining a sendonly multicast group.
>
> What testing has this series received?
>
functional testing against new SM that supports that option and
against old S that doesn't.
regression and stress testing.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
