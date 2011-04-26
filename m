From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Create all directories in database path on
 Windows
Date: Tue, 26 Apr 2011 16:41:41 +0300
Message-ID: <20110426134141.GA9750@calypso.voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD82F9D@orsmsx501.amr.corp.intel.com>
 <3F6F638B8D880340AB536D29CD4C1E1925F1EFC4F0@orsmsx501.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD8326A@orsmsx501.amr.corp.intel.com>
 <BANLkTincBjF3CuHq+q2-Xr5Fby9y-Xox4g@mail.gmail.com>
 <3F6F638B8D880340AB536D29CD4C1E1925F1EFC9BC@orsmsx501.amr.corp.intel.com>
 <BANLkTi=pqaQSir3iCNLiety-jvF2xGJBcw@mail.gmail.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD83A1B@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DCD83A1B-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

On 11:21 Thu 21 Apr     , Hefty, Sean wrote:
> Replace CreateDirectory with SHCreateDirectoryEx, so that
> intermediate directories in the database path are created.
> 
> This fixes an issue where opensm fails to start unless the
> path has been created beforehand.
> 
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> This will sync the opensm.git tree with the windows svn repository
> for this patch.  This is simply to make future updates easier.
> I do not see that the other files that changed are part of git.
> If no one objects, I'll commit to svn once pulled into git.
> 
>  opensm/osm_db_files.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/opensm/osm_db_files.c b/opensm/osm_db_files.c
> index 18ac830..6e9a676
> --- a/opensm/osm_db_files.c
> +++ b/opensm/osm_db_files.c
> @@ -169,8 +169,19 @@ int osm_db_init(IN osm_db_t * p_db, IN osm_log_t * p_log)
>  	/* Create the directory if it doesn't exist */
>  	/* There is a difference in creating directory between windows and linux */
>  #ifdef __WIN__
> -	/* Check if the directory exists. If not - create it. */
> -	CreateDirectory(p_db_imp->db_dir_name, NULL);
> +	{
> +		int ret;
> +
> +		ret = SHCreateDirectoryEx(NULL, p_db_imp->db_dir_name, NULL);
> +		if (ret != ERROR_SUCCESS && ret != ERROR_ALREADY_EXISTS &&
> +			ret != ERROR_FILE_EXISTS) {
> +			OSM_LOG(p_log, OSM_LOG_ERROR, "ERR 0x%x: "
> +				"Failed to create the db directory:%s\n",
> +				ret, p_db_imp->db_dir_name);

Error log messages have special format: "ERR XXYY", where XX should be unique
per each file and YY should be unique for each message within the file.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
