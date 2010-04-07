From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: librdmacm meets libiwarp
Date: Wed, 7 Apr 2010 15:26:02 -0700
Message-ID: <BE20BCF9136E4FAFAC482D50D1A36306@amr.corp.intel.com>
References: <942482910-1270678218-cardhu_decombobulator_blackberry.rim.net-106991531-@bda043.bisx.produk.on.blackberry>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <942482910-1270678218-cardhu_decombobulator_blackberry.rim.net-106991531--vREwkvsugevjL2gL5RxOE1pMnUE8n+ufF6Q+nnUHFY8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: philip.frey-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>it's nice to see, that you seem to have liked most of
>my ideas and intentions of libiwarp :) thanks for
>making that work a bit more sustainable!

Thanks for the input.  I think there could still be a little more work done to
handle completions across shared CQs, plus add in SRQ support.

>I was wondering where I could get a copy of your
>latest code to look at it as a whole and (maybe)
>comment on it.

The code is available from my git tree, in the af_ib branch:

	git://git.openfabrics.org/~shefty/librdmacm.git af_ib

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
