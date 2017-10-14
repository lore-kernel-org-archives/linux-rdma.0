From: "Bernard Metzler" <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: RE: [PATCH v2 06/13] SoftiWarp connection management
Date: Sat, 14 Oct 2017 00:56:45 +0000
Message-ID: <OFD710B7D1.9178C5EA-ON002581B9.00053214-002581B9.00053218@notes.na.collabserv.com>
References: <VI1PR0502MB3008D5916D814D77776C395ED1710@VI1PR0502MB3008.eurprd05.prod.outlook.com>,<20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-7-bmt@zurich.ibm.com>
 <VI1PR0502MB300889B173AC42BD1ADF6F92D1710@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <1507303945.2602.9.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008D5916D814D77776C395ED1710-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

-----Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote: -----

>To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org"
><bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
><linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Date: 10/06/2017 06:05PM
>Subject: RE: [PATCH v2 06/13] SoftiWarp connection management
>
>> -----Original Message-----
>
>> From: Bart Van Assche [mailto:Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org]
>
>> Sent: Friday, October 06, 2017 10:32 AM
>
>> To: bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org; Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; linux-
>
>> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
>> Subject: Re: [PATCH v2 06/13] SoftiWarp connection management
>
>> 
>
>> On Fri, 2017-10-06 at 14:59 +0000, Parav Pandit wrote:
>
>> > > +     BUG_ON(!cep);
>
>> >
>
>> > Do you need BUG_ON or can be converted to WARN__ and return?
>
>> 
>
>> Hello Bernard and Parav,
>
>> 
>
>> Using BUG_ON() in new code is considered unacceptable. See e.g.
>Linus
>
>> Torvalds,
>
>
>
>Yes. However checkpatch.pl shows that as warning instead of error.
>
>It may be worth to change to report that as an error to reflect what
>Linus mentioned in [1].
>
>That allows to catch it even before patch gets posted.
>
>
>
>[1]
>https://urldefense.proofpoint.com/v2/url?u=https-3A__lkml.org_lkml_20
>16_10_4_1&d=DwIGaQ&c=jf_iaSHvJObTbx-siA1ZOg&r=2TaYXQ0T-r8ZO1PP1alNwU_
>QJcRRLfmYTAgd3QCvqSc&m=tbMVPXruAkltYA5JPtSz_QBfl52SZgEMaghx4r6U_Sc&s=
>ayQywk_3kHdY_lD0Nr7WPolhVaE9qQKXQ08ilhemILI&e= 
>
>
>
While I found it useful, I am going to remove all BUG() and
friends statements.

Thanks,
Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
