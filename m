From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [OPENSM] match functions to prototypes in header file
Date: Thu, 1 Oct 2009 12:52:21 -0700
Message-ID: <4D838DBAE5F245EEA72D4466987294E1@amr.corp.intel.com>
References: <3DE88517D38A4EB0B49A2E3AAF96D005@amr.corp.intel.com> <20091001183127.GX17846@me> <20091001185148.GJ19540@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001185148.GJ19540-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>> > @@ -1106,9 +1109,9 @@ void osm_dump_path_record(IN osm_log_t * p_log, IN
>const ib_path_rec_t * p_pr,
>> >  			"\t\t\t\tresv2...................0x%X\n"
>> >  			"\t\t\t\tresv3...................0x%X\n",
>> >  			cl_ntoh64(p_pr->service_id),
>> > -			inet_ntop(AF_INET6, p_pr->dgid.raw, gid_str,
>> > +			inet_ntop(AF_INET6, (void*)p_pr->dgid.raw, gid_str,
>>
>> And why is such casting(s) needed?
>
>Casting away const like that is incorrect, fix your inet_ntop to have
>a POSIX signature or ignore the warning.

The WinOF version of inet_ntop is:

const char *inet_ntop(int af, const void *src, char *dst, socklen_t cnt);

The MS version of inet_ntop (available in vista and later) is:

"The ANSI version of this function is inet_ntop"
PCTSTR WSAAPI InetNtop(
  __in   INT  Family,
  __in   PVOID pAddr,
  __out  PTSTR pStringBuf,
  __in   size_t StringBufSize
);

I'm guessing inet_ntop maps directly to InetNtop, but I can't find the
definition in the header file.  We use the MS version of the function when
available.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
