From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 libibverbs 2/7] Add member functions to poll an
 extended CQ
Date: Tue, 31 May 2016 17:46:38 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB05CA6D@ORSMSX109.amr.corp.intel.com>
References: <1464533475-18949-1-git-send-email-yishaih@mellanox.com>
 <1464533475-18949-3-git-send-email-yishaih@mellanox.com>
 <574B6F71.9060808@redhat.com> <20160529233009.GA12420@obsidianresearch.com>
 <8F7BC9E2-75EC-413B-BEBE-11450225AF06@redhat.com>
 <20160530013507.GA19230@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160530013507.GA19230-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> However, getting this wrong limits the future hardware we can support,
> which is scary, and the branch option clearly doesn't have that
> problem.
> 
> So the performance win would have to be substantial, IMHO.

I agree that we need to be careful about exposing implementation specific details through the API, but we're already partially down that path.  I'm not sure about the best way to measure performance with any proposal.
 
These are more thoughts than questions:  If an app wants to support iWarp/RoCE/OPA, is it just going to have a branch around the calls anyway?  What data is actually needed by the apps?  Is there any relationship between the various calls?  For example, if an app calls read_slid, is it more likely than not to also call read_pkey_index and read_dlid_path_bits, etc.?  Is the app expected to retrieve addressing data piecemeal like this for every possible architecture?  Are 5 function calls better than one call that fills out a structure, when all fields are needed?  Basically, meaningful benchmarks of poll cq likely require including use of the data.

The proposal is the equivalent of C++ accessor functions, which I admit I have never been a fan of, though the use seems simple enough.  And I don't have a better proposal offhand.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
