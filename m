From: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/24] New fast registration API
Date: Mon, 21 Sep 2015 16:28:10 -0700
Message-ID: <5600928A.7070202@oracle.com>
References: <1442482947-27785-1-git-send-email-sagig@mellanox.com>
 <55FDEDD5.1090105@oracle.com> <55FE7E24.20300@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55FE7E24.20300-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi,

On 9/20/15 2:36 AM, Sagi Grimberg wrote:
> Hi Santosh,
>
>> Nice to see this consolidaton happening. I too don't have access to
>> iWARP hardware for RDS test but will use this series and convert our WIP
>> IB fastreg code and see how it goes.
>
> I'm very pleased to hear about this WIP. Please feel free to share
> anything you have (code and questions/dilemmas) with the list. Also, if
> you have more suggestions on how we can do better from your PoV we'd
> love to hear about it.
>
So as promised, I tried to test your series.  Your github branch [1]
'reg_api.3' though mostly has 4.3-rc1 contents, it isn't
based of 4.3-rc1 so I just cherry picked the patches and created
'rdma/sagi/reg_api.3_cherrypick' [2]. I had conflict with iser
patch so I just dropped that one.

As mentioned earlier, I have a WIP RDS fastreg branch [3]
which is functional (at least I can RDMA messages across
nodes ;-)). So merging [2] and [3], I created [4] and applied
a delta change based on your other patches. I saw ib_post_send
failure with my HCA driver returning '-EINVAL'. I didn't
debug it further but at least opcode and num_sge were set
correctly so I shouldn't have seen it. So I did memset()
on reg_wr which seems to have helped to fix the ib_post_send()
failure.

But I got into remote access errors which tells me that I
have messed up setup(rkey, sge setup or access flags)
or missing some other patch(s) in my test tree[4]. Delta
patch is top commit on [4].

Please let me know if you spot something which I missed.

Regards,
Santosh

[1] https://github.com/sagigrimberg/linux/tree/reg_api.3
[2] 
https://git.kernel.org/cgit/linux/kernel/git/ssantosh/linux.git/log/?h=rdma/sagi/reg_api.3_cherrypick
[3] 
https://git.kernel.org/cgit/linux/kernel/git/ssantosh/linux.git/log/?h=net/rds/4.3-fr-wip
[4]https://git.kernel.org/cgit/linux/kernel/git/ssantosh/linux.git/commit/?h=test/reg_api.3/rds
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
