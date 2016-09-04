From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sun, 4 Sep 2016 15:07:26 +0000
Message-ID: <BLUPR02MB168399680A6189C32991C55481E70@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <4f0876ce-f3c9-83e3-d0ef-0c5656ce9462@grimberg.me>
 <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com>
 <20160901172355.GA20472@obsidianresearch.com>
 <32d92e4b-5b5a-a49c-4466-2db33de3a4f1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/04/16 00:55, Sagi Grimberg wrote:=0A=
>> Seems reasonable and on theme.=0A=
>>=0A=
>> What do you want to do with the emulate_udev directory? It doesn't=0A=
>> even look like it is built..=0A=
>=0A=
> I think we can safely drop it. It's been there forever and never been=0A=
> used AFAIK. Bart?=0A=
=0A=
It is safe to remove that code. I have dropped it from the official =0A=
srptools repository.=0A=
=0A=
Bart.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
