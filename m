From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Sat, 3 Sep 2016 14:08:24 +0000
Message-ID: <BLUPR02MB16836859F638150FF6330A0A81E40@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <4f0876ce-f3c9-83e3-d0ef-0c5656ce9462@grimberg.me>
 <53eb35b4-0320-acd9-9969-73f5817c8144@sandisk.com>
 <20160901172355.GA20472@obsidianresearch.com>
 <019b01d2047f$b9694f90$2c3beeb0$@opengridcomputing.com>
 <20160902233231.GA26309@obsidianresearch.com>
 <ef8214f8-d44d-2289-d1ed-a0998e9e05c0@sandisk.com>
 <20160903051222.GA2098@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/02/16 22:12, Jason Gunthorpe wrote:=0A=
> On Fri, Sep 02, 2016 at 05:10:45PM -0700, Bart Van Assche wrote:=0A=
>> -%define CMAKE_FLAG=0A=
>> +%define CMAKE_FLAG %{nil}=0A=
>=0A=
> Weird, I didn't know opensuse rpmbuild was different.. But that hunk is=
=0A=
> fine, c6 and c7 accept it as well, but don't need it..=0A=
=0A=
Hello Jason,=0A=
=0A=
I don't think that "%define CMAKE_FLAG" is syntactically valid. See e.g. =
=0A=
http://stackoverflow.com/questions/3474674/how-to-define-a-rpm-spec-macro-w=
ith-empty-body.=0A=
=0A=
> So I added opensuse 13.2 and 42.1 to the list of docker container=0A=
> builders and the simple build looks like it runs OK.=0A=
>=0A=
> But rpmbuild chokes even after the above fix.=0A=
>=0A=
> What suse version are you using to have any success at all? I suppose=0A=
> it isn't available in docker?=0A=
=0A=
On my development system I run openSuSE Tumbleweed, a rolling release. I =
=0A=
update it every now and then by running "zypper dist-upgrade". Some of =0A=
our production systems run SLES 12 SP2; others run RHEL 6 or RHEL 7.=0A=
=0A=
Bart.=0A=
=0A=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
