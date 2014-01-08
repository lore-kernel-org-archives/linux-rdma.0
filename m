From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/usnic: Expose flows via debugfs
Date: Wed, 8 Jan 2014 11:13:50 +0200
Message-ID: <52CD16CE.7080804@mellanox.com>
References: <6F4F8D2C-F10F-4697-ABD5-552D2E696361@cisco.com> <52B6BDAF.6030407@mellanox.com> <BC780FB0-731D-42FA-B003-E61B473B23E2@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BC780FB0-731D-42FA-B003-E61B473B23E2-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/01/2014 00:29, Upinder Malhi (umalhi) wrote:
> Or, The flows contain Cisco VIC specific stuff - Ex. the hardware flow id; and they will contain more cisco specific things.  Hence, they are exported via debugfs.

You should be able to enhance the rdma netlink infrastructure to allow 
for exporting HW dependent attributes to user space -- did you look on 
that?

Also, you should make sure to expose the non HW specific attributes of 
the sessions through the standard infrastructure.

Or.




>
> Upinder
>
> On Dec 22, 2013, at 2:23 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> On 20/12/2013 23:37, Upinder Malhi (umalhi) wrote:
>>> This patch depends onhttp://www.spinics.net/lists/linux-rdma/msg18193.html
>> Why use proprietary debugfs code  to display flows? you can (and should) use the rdma subsystem netlink infrastructure for that, see these
>> two commits
>>
>>
>> 753f618 RDMA/cma: Add support for netlink statistics export
>> b2cbae2 RDMA: Add netlink infrastructure
>>
>>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
