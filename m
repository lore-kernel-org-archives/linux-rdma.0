From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Create all directories in database path on
 Windows
Date: Fri, 29 Apr 2011 11:59:33 +0300
Message-ID: <20110429085933.GA25031@calypso.voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD82F9D@orsmsx501.amr.corp.intel.com>
 <3F6F638B8D880340AB536D29CD4C1E1925F1EFC4F0@orsmsx501.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD8326A@orsmsx501.amr.corp.intel.com>
 <BANLkTincBjF3CuHq+q2-Xr5Fby9y-Xox4g@mail.gmail.com>
 <3F6F638B8D880340AB536D29CD4C1E1925F1EFC9BC@orsmsx501.amr.corp.intel.com>
 <BANLkTi=pqaQSir3iCNLiety-jvF2xGJBcw@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD83A1B@orsmsx501.amr.corp.intel.com>
 <20110426134141.GA9750@calypso.voltaire.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3BD2@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3BD2-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:31 Thu 28 Apr     , Hefty, Sean wrote:
> Replace CreateDirectory with SHCreateDirectoryEx, so that
> intermediate directories in the database path are created.
> 
> This fixes an issue where opensm fails to start unless the
> path has been created beforehand.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> change from v1: used common error handling
> 

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
