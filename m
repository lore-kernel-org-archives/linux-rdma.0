From: Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [PATCH RFC] svcrdma: Ignore source port when computing DRC hash
Date: Thu, 6 Jun 2019 09:24:04 -0400
Message-ID: <BD1CF3FF-887A-4204-AE3F-D48D51442E70@oracle.com>
References: <20190605121518.2150.26479.stgit@klimt.1015granger.net>
 <20190606130804.19EE32070B@mail.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190606130804.19EE32070B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On Jun 6, 2019, at 9:08 AM, Sasha Levin <sashal@kernel.org> wrote:
>=20
> Hi,
>=20
> [This is an automated email]
>=20
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: =
all
>=20
> The bot has tested the following trees: v5.1.7, v5.0.21, v4.19.48, =
v4.14.123, v4.9.180, v4.4.180.
>=20
> v5.1.7: Build OK!
> v5.0.21: Build OK!
> v4.19.48: Build OK!
> v4.14.123: Build OK!
> v4.9.180: Build failed! Errors:
>    net/sunrpc/xprtrdma/svc_rdma_transport.c:712:2: error: implicit =
declaration of function =E2=80=98rpc_set_port=E2=80=99; did you mean =
=E2=80=98rpc_net_ns=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>=20
> v4.4.180: Build failed! Errors:
>    net/sunrpc/xprtrdma/svc_rdma_transport.c:635:2: error: implicit =
declaration of function =E2=80=98rpc_set_port=E2=80=99; did you mean =
=E2=80=98rpc_net_ns=E2=80=99? [-Werror=3Dimplicit-function-declaration]
>=20
>=20
> How should we proceed with this patch?

If the review completes without objection, I will resubmit
this patch with an updated Cc: . Thanks for testing!
