From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 problems with 4.2-rc8
Date: Tue, 1 Sep 2015 09:40:44 +0300
Message-ID: <CAJ3xEMh-EXsoWsMhSf2ho_U_tz5tCUz2iWK+YZ3d76j5B7HJxg@mail.gmail.com>
References: <55E142DC.8060205@redhat.com>
	<CAJ3xEMj5By11L3qbSKxcEiMarB6CeyeERMnuK_vvH11VLLFypw@mail.gmail.com>
	<55E385DB.2@redhat.com>
	<55E3FDAB.10706@mellanox.com>
	<55E45058.1070105@redhat.com>
	<CAJ3xEMjp+3Y0y2d-K-zi9SnBSshN_C5x5KLY3oCpD_XriDCsWw@mail.gmail.com>
	<55E4D1A1.3060608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E4D1A1.3060608-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 1, 2015 at 1:13 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 08/31/2015 04:21 PM, Or Gerlitz wrote:
>> On Mon, Aug 31, 2015 at 4:02 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> On 08/31/2015 03:09 AM, Matan Barak wrote:
>>
>>>> Actually, it looks like the dump stack we've got before [1] was fixed.
>>>> This happens when the mlx4 driver is used in setups where number of
>>>> cores >= 32.
>>
>>>> Doug, is that the case?
>>
>>> Indeed, 48 cores on this machine.
>>
>> so do we have bingo here? the patch is in the net-next tree (and we
>> can't put it in 4.2 only through -stable since 4.2 is released by
>> now), does it solves the problem?
>
> Yes, it solved the problem.  I pulled the patch into my testing branch
> to confirm.

Good. Something is still strange w.r.t your environment... you said that
when you  were submitting the 4.2-rc changes this machine worked, however
the problematic code in mlx4_enable_msi_x existed there by the time you
made that testing, Matan  - agree?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
