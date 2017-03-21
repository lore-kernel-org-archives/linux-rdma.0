From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: rdma-core and endianness checking with sparse
Date: Tue, 21 Mar 2017 17:56:23 +0000
Message-ID: <1490118969.2605.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <9A1774B42F72714B9A23B8EEC37C22CF-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Jason,

Since commit https://github.com/linux-rdma/rdma-core/commit/dceee9494bfbadf=
0cf16b8fef81f3c2cb5355243
checking endianness locally with sparse is broken on my development setup.
The following error messages appear:

-- Performing Test HAVE_NO_SPARSE
-- Performing Test HAVE_NO_SPARSE - Failed
Patch from '/home/bart/software/infiniband/rdma-core/buildlib/sparse-includ=
e/19/netinet-in.h.diff' failed
Patch from '/home/bart/software/infiniband/rdma-core/buildlib/sparse-includ=
e/23/netinet-in.h.diff' failed
Traceback (most recent call last):
=A0 File "/home/bart/software/infiniband/rdma-core/buildlib/gen-sparse.py",=
 line 129, in <module>
=A0=A0=A0=A0replace_header(I);
=A0 File "/home/bart/software/infiniband/rdma-core/buildlib/gen-sparse.py",=
 line 82, in replace_header
=A0=A0=A0=A0raise ValueError("Unable to apply any patch to %r, tries %u"%(f=
n,tries));
ValueError: Unable to apply any patch to 'netinet/in.h', tries 2

I was surprised to see that merge request in the rdma-core repository altho=
ugh
I had warned from beforehand that this could happen?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
