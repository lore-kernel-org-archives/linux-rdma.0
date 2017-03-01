From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Poll CQ syncing problem
Date: Wed, 1 Mar 2017 16:52:36 +0000
Message-ID: <1488387143.2699.6.camel@sandisk.com>
References: <b4355d22-fc79-c860-de8a-5a4d468c884d@mellanox.com>
         <3ba1baab-e2ac-358d-3b3b-ff4a27405c93@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3ba1baab-e2ac-358d-3b3b-ff4a27405c93-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <973EA529DDC4AB43B19FAC75A12BD11A-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-01 at 16:30 +0200, Noa Osherovich wrote:
> REGS: c0000001ce7077e0 TRAP: 0300=A0=A0 Not tainted=A0 (2.6.32-642.el6.pp=
c64)

Hello Noa,

I agree with Christoph and Sagi that your analysis doesn't match the upstre=
am
code. I think the above information means that you are using RHEL 6.8?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
