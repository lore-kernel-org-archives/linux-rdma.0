From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] ib_srp: Let compiler ignore the useless debug code
Date: Fri, 24 Feb 2017 16:16:31 +0000
Message-ID: <1487952911.2575.1.camel@sandisk.com>
References: <20170224084451.42117-1-mnghuan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170224084451.42117-1-mnghuan@gmail.com>
Content-Language: en-US
Content-ID: <19F6D91DE058AF44A730D92D2F228086@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "mnghuan@gmail.com" <mnghuan@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-02-24 at 16:44 +0800, Minfei Huang wrote:
> "if (0)" is used to make this block of debug code not be executed. There
> is a more elegant way to let compiler ignore this code, using
> "#if 0 .. #endif" instead.
>=20
> Although it may be optimised by some compilers with specified parameter,
> just for readable.

#if 0 / #endif prevents the compiler from checking the syntax of the code.
Such code tends to grow syntax errors. So I'm not sure this patch is an
improvement.

Bart.=
