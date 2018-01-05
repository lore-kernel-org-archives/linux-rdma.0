From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 00/14] index e382a3ca759e..d4a471a76d82 100644
Date: Fri, 5 Jan 2018 17:22:14 +0200
Message-ID: <CAJ3xEMjOGEQQf+y4wEEPiS_F9fhYmDwBmd=ucUDQX_9416gzKQ@mail.gmail.com>
References: <20180104152544.28919-1-leon@kernel.org> <CAJ3xEMjptQf99ZdGxkB6kTh9LkQ7-pjiObMh+knDWXFStPOg7Q@mail.gmail.com>
 <2618f285-6fa4-06ac-4b4a-51d0b2660b61@mellanox.com> <CAJ3xEMhVxBqJUwdRn3BXJPnf9J-_gXtrWrQgun3bCEW7W7Oq1w@mail.gmail.com>
 <792bac90-b1eb-110f-399c-08d5309d92dd@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <792bac90-b1eb-110f-399c-08d5309d92dd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 5, 2018 at 5:03 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 1/5/2018 8:59 AM, Or Gerlitz wrote:

>>> Operating this way isn't ideal though.  In DPR mode the FW biases the schedule queue
>>> allocation to the master port. Performance could be worse on the VFs that could be slave
>>> ports if they are used as normal IB devices.

>> So the FW doesn't have any indication that these driver instances are
>> unware to what's going
>> on? doesn't sounds ideal as you said and as life are. It's uneasy to
>> come up with designs
>> that would let the different Unmodified/Modified PF/VF combinations
>> (U/M M/U) work @ their
>> best, but we should aim there, this time it sounds that didn't work
>> and we will have to live with
>> that unless you can think on a way to get the FW signal that to
>> themselves and avoid the bias.

> The schedule queue allocation happens during FW boot, even before the PF drivers are loaded.
> I don't think there's any way around it in this case.

You mentioned PF drivers.. in multi-host config we can run into the
same U/M M/U problem.
some hosts/PF instances run the modified code and while other
hosts/PFs unmodified code,
or in this case the U PFs will not enable the feature? and if this is
the case, the FW does know
how to handle U PFs and their VFs?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
