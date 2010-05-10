From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ummunotify: Userspace support for MMU notifications V2
Date: Mon, 10 May 2010 10:12:56 -0700
Message-ID: <56643C62C30044F0A734365A5274C821@amr.corp.intel.com>
References: <1271943493-12120-1-git-send-email-ebmunson@us.ibm.com> <01C0A6AB-E4B6-4B56-AFAE-52952D152110@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <01C0A6AB-E4B6-4B56-AFAE-52952D152110-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jeff Squyres' <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
>> and follow-up messages, libraries using RDMA would like to track
>> precisely when application code changes memory mapping via free(),
>> munmap(), etc.  Current pure-userspace solutions using malloc hooks
>> and other tricks are not robust, and the feeling among experts is that
>> the issue is unfixable without kernel help.
>
>Sorry for not replying earlier -- just to throw in my $0.02 here: the MPI
>community is *very interested* in having this stuff in upstream kernels.  It
>solves a fairly major problem for us.
>
>Open MPI (www.open-mpi.org) is ready to pretty much immediately take advantage
>of these capabilities.  The code to use ummunotify is in a Mercurial branch;
>we're only waiting for ummunotify to go upstream before committing our support
>for it to our main SVN development trunk.

Intel's MPI team has examined this proposal as well and would also like to see
this merged upstream.  It is helpful implementing MPI over RDMA devices.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
