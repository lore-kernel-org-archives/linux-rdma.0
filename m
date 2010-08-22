From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Sun, 22 Aug 2010 09:15:17 +0200
Message-ID: <AANLkTinQDzch3gYzOy0HA6eJs6A403iE5zUxhBMJbmmo@mail.gmail.com>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm>
	<1282408043.20840.13.camel@obelisk.thedillows.org>
	<AANLkTimFS=QkHd9+393mS1gQ5ZnL79jSDQaUZ8C_Xd2A@mail.gmail.com>
	<201008212020.55028.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201008212020.55028.bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 21, 2010 at 8:20 PM, Bernd Schubert
<bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org> wrote:
> On Saturday, August 21, 2010, Bart Van Assche wrote:
>> [ ... ]
>> task attribute SIMPLE, so a target is allowed to process these
>> requests concurrently. For the ib_srpt target I see the following
>> results over a single QDR link and a NULLIO target (fio
>> --bs=3D$((1020*1024)) --ioengine=3Dpsync --buffered=3D0 --rw=3Dread =
--thread
>> --numjobs=3D${threads} --group_reporting --gtod_reduce=3D1 --name=3D=
${dev}
>> --filename=3D${dev}):
>>
>> I/O depth Bandwidth (MB/s)
>> =A0 =A0 1 =A0 =A0 =A0 1270
>> =A0 =A0 2 =A0 =A0 =A0 2300
>> =A0 =A0 4 =A0 =A0 =A0 2500
>> =A0 =A0 8 =A0 =A0 =A0 2670
>> =A0 =A016 =A0 =A0 =A0 2700
>>
>> That last result is close to the bandwidth reported by ib_rdma_bw.
>
> How exactly do you do that? Is that something I would try with our st=
orage as
> well? I guess only with a special firmware version, which I also do n=
ot have
> access to.

=46or me it doesn't matter whether you use xdd or fio to repeat the
above test. In case you prefer fio: more information about fio can be
found here: http://freshmeat.net/projects/fio/. It is safe to run the
above fio command since it doesn't modify any data. Even if you do not
configure the target for NULLIO but read real data instead, repeating
the above test will reveal whether the IB link is the bottleneck or
the storage system inside the target device.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
