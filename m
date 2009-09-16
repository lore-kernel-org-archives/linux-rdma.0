From: Chris Worley <worleys@gmail.com>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow reads
	and eventually hangs
Date: Wed, 16 Sep 2009 09:11:15 -0600
Message-ID: <f3177b9e0909160811i5c490577k8298e5d1ff920b27@mail.gmail.com>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>
	<e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>
	<f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>
	<4AAFC42D.4030708@vlnb.net>
	<f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>
	<4AAFC794.7090205@vlnb.net>
	<f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>
	<4AAFCA77.6050305@vlnb.net>
	<f3177b9e0909151351p12173c78oe01cc8bcca957550@mail.gmail.com>
	<e2e108260909160003n7d9170edl8289c6fce4f8225c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <e2e108260909160003n7d9170edl8289c6fce4f8225c@mail.gmail.com>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-rdma@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, Vladislav Bolkhovitin <vst@vlnb.net>, OpenIB <general@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 16, 2009 at 1:03 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On Tue, Sep 15, 2009 at 10:51 PM, Chris Worley <worleys@gmail.com> wrote:
>> In lots of testing today, I've seen this panic twice on the Ubuntu 8.10 =
targets:
>>
>> [ =A0330.155992] ib_srpt: disconnected session
>> 0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
>> been received.
>
> The above message means that an initiator logged in, did not log out
> and logged in again. Has one of the initiator systems e.g. been power
> cycled while an SRP connection was active ?

Yes.  Once ib_srp is hung on one device, I re-login to get the device
and test again.  I can't log out of the previous, as it's hung... this
"hanging" is the issue I'm having.  When I re-login, I get a new
device... i.e. I hung /dev/sdc and re-login to get /dev/sdd... then
test that until it hangs.

Using the ramdisks makes the problem much easier to trigger, and
occasionally causes the panic, especially using:

fio --rw=3Drandrw --bs=3D1k --numjobs=3D64 --iodepth=3D64 --sync=3D0 \
   --direct=3D1 --randrepeat=3D0  --group_reporting --ioengine=3Dlibaio \
   --filename=3D/dev/sdp --name=3Dtest --loops=3D10000 --runtime=3D1600 \
   --rwmixread=3D100

...on the initiator to cause it.

Chris
>
>> [ =A0357.207046] ib_srpt: srpt_xmit_response: tag=3D 17 channel in bad s=
tate 2
>
> This means that an attempt was made by SRPT to transmit a response for
> a channel in the state 2 (disconnecting). This must be analyzed
> further, just like the bug report triggered from
> srpt_abort_scst_cmd().
>
> [ ... ]
>
>> [ =A0411.636699] WARNING: at /root/scst/srpt/src/ib_srpt.c:924
>> srpt_abort_scst_cmd+0xac/0x160 [ib_srpt]()
>> ...
>
> This message has been triggered by the statement WARN_ON("unexpected
> cmd state"). It must be analyzed whether this is a consequence of what
> went wrong before or whether this is a separate issue.
>
> [ ... ]
>
>> This may have been due to low memory, as I was using most target
>> memory for the ramdisk.
>
> The kernel warning message in ib_srpt.c at line 924 should never be
> triggered, not even under low memory circumstances. I'll have a look
> at this anyway.
>
> Thanks for the detailed report.
>
> Bart.
>
